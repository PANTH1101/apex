package com.eventmanagement.service;

import com.eventmanagement.dto.UpdateProfileRequest;
import com.eventmanagement.dto.UserResponse;
import com.eventmanagement.entity.User;
import com.eventmanagement.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public UserResponse getUserProfile(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        
        return UserResponse.fromUser(user);
    }

    public UserResponse updateUserProfile(String email, UpdateProfileRequest request) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Update only allowed fields
        if (request.getName() != null && !request.getName().isBlank()) {
            user.setName(request.getName());
        }

        if (request.getPhone() != null) {
            user.setPhone(request.getPhone());
        }

        User updatedUser = userRepository.save(user);
        return UserResponse.fromUser(updatedUser);
    }
}
