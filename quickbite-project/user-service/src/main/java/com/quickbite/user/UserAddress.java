package com.quickbite.user;

import jakarta.persistence.*;

@Entity
@Table(name = "user_addresses")
public class UserAddress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String address;
    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id")
    private User user;

    protected UserAddress() {}
}
