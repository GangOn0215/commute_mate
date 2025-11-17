package com.example.hello.common.enums;

import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum PostsCategory {
    GENERAL("자유"),
    QUESTION("질문"),
    COMPANY("회사"),
    COMMUTE("출퇴근"),
    DAILY("일상"),
    CAT("고양이"),
    NOTICE("공지사항");

    private final String description;

    // 이 메서드가 JSON 직렬화 시 사용됨
    @JsonValue
    public String getDescription() {
        return description;
    }
}
