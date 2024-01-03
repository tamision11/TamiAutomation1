package entity;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import enums.data.RoomStatus;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

/**
 * User: nirtal
 * Date: 16/07/2021
 * Time: 23:40
 * Created with IntelliJ IDEA
 */
@RequiredArgsConstructor
@JsonInclude(JsonInclude.Include.NON_EMPTY)
@Data
public class Room {
    @NonNull
    @JsonProperty("roomId")
    private Integer id;
    @NonNull
    private Provider provider;
    private String caseId;
    private String sessionReportId;
    private RoomStatus roomStatus;
    private boolean isB2B;
    private boolean isCancellable;

    public Room(@NonNull Integer id, @NonNull Provider provider, RoomStatus roomStatus, boolean isB2B, boolean isCancellable) {
        this.id = id;
        this.provider = provider;
        this.roomStatus = roomStatus;
        this.isB2B = isB2B;
        this.isCancellable = isCancellable;
    }
}
