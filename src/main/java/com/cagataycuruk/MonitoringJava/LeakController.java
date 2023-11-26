package com.cagataycuruk.MonitoringJava;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

record Person(byte[] name) {}

@RestController
class LeakController {

    private final List<Person> leakyStorage = new ArrayList<>();

    @GetMapping("/leak")
    public String leak() {
        for (int i = 0; i < 10000; i++) {
            leakyStorage.add(new Person(new byte[1024]));
        }
        return "Leak Triggered";
    }

    @GetMapping("/leak-count")
    public Integer leakCount() {
        return leakyStorage.size();
    }
}