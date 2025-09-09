package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Place {
    private int id;             // 기본키
    private String name;        // 상호명
    private int type;           // 10=병원, 20=편의점
    private String addr;        // 주소
    private double lat;         // 위도
    private double lng;         // 경도
    private String img;         // 이미지 파일명
    private Timestamp regdate;  // 등록일
}