package com.eventmanagement.controller;

import com.eventmanagement.dto.UpdateProfileRequest;
import com.eventmanagement.dto.UserResponse;
import com.eventmanagement.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/me")
    public ResponseEntity<UserResponse> getCurrentUser(Authentication authentication) {
        String email = authentication.getName();
        UserResponse response = userService.getUserProfile(email);
        return ResponseEntity.ok(response);
    }

    @PutMapping("/me")
    public ResponseEntity<UserResponse> updateCurrentUser(
            @Valid @RequestBody UpdateProfileRequest request,
            Authentication authentication
    ) {
        String email = authentication.getName();
        UserResponse response = userService.updateUserProfile(email, request);
        return ResponseEntity.ok(response);
    }
}
