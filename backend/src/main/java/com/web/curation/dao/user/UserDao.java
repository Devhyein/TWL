
package com.web.curation.dao.user;

import java.util.Optional;

import com.web.curation.model.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserDao extends JpaRepository<User, String> {
    User getUserByEmail(String email);

    Optional<User> findUserByEmailAndPassword(String email, int password);
    
    User save(User user);

    Optional<User> findUserByEmail(String email);
    Optional<User> findUserByNickname(String nickname);

  }