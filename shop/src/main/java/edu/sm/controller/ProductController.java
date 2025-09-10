package edu.sm.controller;


import com.github.pagehelper.PageInfo;
import edu.sm.app.dto.Cust;
import edu.sm.app.dto.Product;
import edu.sm.app.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/product")
@RequiredArgsConstructor
public class ProductController {

    final ProductService productService;

    String dir = "product/";
    @RequestMapping("")
    public String product(Model model) {
        model.addAttribute("left", dir+"left");
        model.addAttribute("center", dir+"center");
        return "index";
    }
    @RequestMapping("/add")
    public String add(Model model) {
        model.addAttribute("left", dir+"left");
        model.addAttribute("center", dir+"add");
        return "index";
    }
    @RequestMapping("/delete")
    public String delete(Model model, @RequestParam("id") int id) throws Exception {
        productService.remove(id);
        return "redirect:/product/get";
    }
    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("id") int id) throws Exception {
        Product product = null;
        product = productService.get(id);
        model.addAttribute("p", product);
        model.addAttribute("left", dir+"left");
        model.addAttribute("center", dir+"detail");
        return "index";
    }
    @RequestMapping("/registerimpl")
    public String registerimpl(Model model, Product product) throws Exception {
        productService.register(product);
        return "redirect:/product/get";
    }
    @RequestMapping("/updateimpl")
    public String updateimpl(Product product) throws Exception {
        productService.modify(product);
        return "redirect:/product/detail?id="+product.getProductId();
    }
    @RequestMapping("/get")
    public String get(Model model) throws Exception {
        List<Product> list = null;
        list = productService.get();
        model.addAttribute("plist", list);
        model.addAttribute("left", dir+"left");
        model.addAttribute("center", dir+"get");
        return "index";
    }
    @RequestMapping("/getpage")
    public String getpage(@RequestParam(value="pageNo", defaultValue = "1") int pageNo, Model model) throws Exception {
        PageInfo<Product> list = null;
        list = new PageInfo<>(productService.getPage(pageNo), 3); // 5:하단 네비게이션 개수
        model.addAttribute("target", "/product");
        model.addAttribute("clist", list);
        model.addAttribute("left",dir+"left");
        model.addAttribute("center",dir+"getpage");
        return "index";
    }
    @RequestMapping("/addimpl")
    public String addimpl(Product product) throws Exception {
        log.info("Input Date {},{}",
                product.getProductName(),
                product.getProductImgFile().getOriginalFilename());
        productService.register(product);
        return "redirect:/product/get";
    }
}