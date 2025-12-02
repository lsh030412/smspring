package edu.sm.controller;



import ch.qos.logback.classic.LoggerContext;
import edu.sm.app.dto.AdminMsg;
import edu.sm.app.service.LoggerService1;
import edu.sm.app.service.LoggerService2;
import edu.sm.app.service.LoggerService3;
import edu.sm.app.service.LoggerService4;
import edu.sm.sse.SseEmitters;
import edu.sm.util.FileUploadUtil;
import edu.sm.util.WeatherUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.json.simple.parser.ParseException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MainRestController {

    @Value("${app.key.wkey}")
    String wkey;



    private final LoggerService1 loggerService1;
    private final LoggerService2 loggerService2;
    private final LoggerService3 loggerService3;
    private final LoggerService4 loggerService4;
    private final SseEmitters sseEmitters;

    @RequestMapping("/savedata1")
    public Object savedata1(@RequestParam("data") String data) throws IOException {
        loggerService1.save1(data);

        // SSE 메시지 전송
        AdminMsg msg = new AdminMsg();
        msg.setContent1(Integer.parseInt(data));
        sseEmitters.sendData(msg);

        return "OK";
    }

    @RequestMapping("/savedata2")
    public Object savedata2(@RequestParam("data") String data) throws IOException {
        loggerService2.save2(data);

        AdminMsg msg = new AdminMsg();
        msg.setContent2(Integer.parseInt(data));
        sseEmitters.sendData(msg);

        return "OK";
    }

    @RequestMapping("/savedata3")
    public Object savedata3(@RequestParam("data") String data) throws IOException {
        loggerService3.save3(data);

        AdminMsg msg = new AdminMsg();
        msg.setContent3(Integer.parseInt(data));
        sseEmitters.sendData(msg);

        return "OK";
    }

    @RequestMapping("/savedata4")
    public Object savedata4(@RequestParam("data") String data) throws IOException {
        loggerService4.save4(data);

        AdminMsg msg = new AdminMsg();
        msg.setContent4(Integer.parseInt(data));
        sseEmitters.sendData(msg);

        return "OK";
    }
    @RequestMapping("/saveaudio")
    public String saveaudio(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/audios/");
        return "Ok";
    }
    @RequestMapping("/saveimg")
    public String saveimg(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/imgs/");
        return "Ok";
    }

    @RequestMapping("/getwt1")
    public Object getwt1(@RequestParam("loc") String loc) throws IOException, ParseException {
        return WeatherUtil.getWeather(loc,wkey);
    }

    @RequestMapping("/getwt2")
    public Object getwt2(@RequestParam("loc") String loc) throws IOException, ParseException {
        return WeatherUtil.getWeather(loc,wkey);
    }
    @RequestMapping("/getfcwt2")
    public Object getfcwt2(@RequestParam("loc") String loc) throws IOException, ParseException {
        return WeatherUtil.getWeatherForecast(loc,wkey);
    }

}

