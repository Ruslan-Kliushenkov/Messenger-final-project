package com.kliushenkov.Finalproject.controller;


import com.kliushenkov.Finalproject.entities.Message;
import com.kliushenkov.Finalproject.entities.User;
import com.kliushenkov.Finalproject.repository.MessageRepo;
import com.kliushenkov.Finalproject.repository.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import java.util.UUID;

@Controller
public class MainController {
    @Autowired
    private MessageRepo messageRepo;
    private LocalDateTime localDateTime = LocalDateTime.now();
    @Autowired
    private UserRepo userRepo;
    @Value("${upload.path}")
    private String uploadPath;

    @GetMapping("/")
    public String greeting(Map<String, Object> model) {
        return "greeting";
    }

    @GetMapping("/main")
    public String main(@RequestParam(required = false, defaultValue = "") String filter, Model model) {
        Iterable<Message> messages = messageRepo.findAll();

        if (filter != null && !filter.isEmpty()) {
            messages = messageRepo.findByTag(filter);
        } else {
            messages = messageRepo.findAll();
        }

        model.addAttribute("messages", messages);
        model.addAttribute("filter", filter);

        return "main";
    }

    @PostMapping("/mainPost")
    public String add(
            @AuthenticationPrincipal User user,
            @RequestParam String text,
            @RequestParam String tag, Map<String, Object> model,
            @RequestParam("file") MultipartFile file
    ) throws IOException {

        if (!text.replaceAll(" ", "").equals("")) {
            Message message = new Message(text, tag, user);

            if (file != null && !file.getOriginalFilename().isEmpty()) {
                File uploadDir = new File(uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                String uuidFile = UUID.randomUUID().toString();
                String resultFilename = uuidFile + "." + file.getOriginalFilename();

                file.transferTo(new File(uploadPath + "/" + resultFilename));

                message.setFilename(resultFilename);
            }
            message.setLikes(0L);
            message.setMessageComment(Collections.singleton("..."));
            message.setDate(localDateTime.getMonth() + " " + String.valueOf(localDateTime.getDayOfWeek()).toLowerCase() + " " + localDateTime.getHour() + ":" + localDateTime.getMinute());
            messageRepo.save(message);
        }
        Iterable<Message> messages = messageRepo.findAll();

        model.put("messages", messages);

        return "redirect:/main";
    }

    @PostMapping("delete")
    public String delete(@RequestParam String id, Map<String, Object> model) {

        if (id.matches("[0-9]+")) {
            if (messageRepo.findById(Long.parseLong(id)).isPresent()) {
                messageRepo.deleteById(Long.parseLong(id));
            }
        }
        Iterable<Message> messages = messageRepo.findAll();

        model.put("messages", messages);


        return "redirect:/main";
    }

    @PostMapping("deleteButton")
    public String deleteButton(@RequestParam String id, Map<String, Object> model) {

        if (id.matches("[0-9]+")) {
            if (messageRepo.findById(Long.parseLong(id)).isPresent()) {
                messageRepo.deleteById(Long.parseLong(id));
            }
        }
        Iterable<Message> messages = messageRepo.findAll();

        model.put("messages", messages);
        return "redirect:/main";
    }

    @PostMapping("like")
    public String likeButton(
            @RequestParam("messageId") Message message,
            @AuthenticationPrincipal User user,
            Map<String, Object> model) {

        if (!user.isLiked(message.getId())) {
            user.addLikeMessage(message.getId());
            message.likeInc();
            userRepo.save(user);
            messageRepo.save(message);
        } else {
            user.deleteLikeMessage(message.getId());
            message.likeDec();
            userRepo.save(user);
            messageRepo.save(message);
        }

        Iterable<Message> messages = messageRepo.findAll();
        model.put("messages", messages);
        return "redirect:/main";
    }

    @PostMapping("comment")
    public String comment(
            @RequestParam("comment") String comment,
            @RequestParam("messageId") Message message,
            @AuthenticationPrincipal User user,
            Map<String, Object> model) {
        message.addComment(user.getUsername()+": "+comment);
        messageRepo.save(message);
        Iterable<Message> messages = messageRepo.findAll();
        model.put("messages", messages);
        return "redirect:/main";
    }

}
