package com.eventmanagement.dto;

import com.eventmanagement.entity.Role;
import com.eventmanagement.entity.User;

import java.time.LocalDateTime;

public class UserResponse {

    private Long id;
    private String name;
    private String email;
    private Role role;
    private String phone;
    private LocalDateTime createdAt;

    // Constructors
    public UserResponse() {
    }

    public UserResponse(Long id, String name, String email, Role role, String phone, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.role = role;
        this.phone = phone;
        this.createdAt = createdAt;
    }

    // Factory method to create from User entity
    public static UserResponse fromUser(User user) {
        return new UserResponse(
            user.getId(),
            user.getName(),
            user.getEmail(),
            user.getRole(),
            user.getPhone(),
            user.getCreatedAt()
        );
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
