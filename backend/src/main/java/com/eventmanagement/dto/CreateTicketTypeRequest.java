package com.eventmanagement.dto;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

public class CreateTicketTypeRequest {

    @NotBlank(message = "Ticket type name is required")
    @Size(min = 2, max = 100, message = "Ticket type name must be between 2 and 100 characters")
    private String name;

    @Size(max = 500, message = "Description cannot exceed 500 characters")
    private String description;

    @NotNull(message = "Price is required")
    @DecimalMin(value = "0.00", message = "Price must not be negative")
    private BigDecimal price;

    @NotNull(message = "Capacity is required")
    @Min(value = 1, message = "Capacity must be greater than zero")
    private Integer capacity;

    public CreateTicketTypeRequest() {
    }

    // ── Getters and Setters ───────────────────────────────────────────────────

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
}