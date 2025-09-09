package edu.sm.app.dto;
import lombok.*;

import java.sql.Timestamp;
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Marker {
    int target;
    String title;
    String img;
    double lat;
    double lng;
    int loc;
}
