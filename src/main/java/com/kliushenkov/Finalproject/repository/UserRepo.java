package com.kliushenkov.Finalproject.repository;

import com.kliushenkov.Finalproject.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepo extends JpaRepository<User, Long> {
    User findByUsername(String username);
}