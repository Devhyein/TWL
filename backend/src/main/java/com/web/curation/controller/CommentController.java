package com.web.curation.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.time.LocalDateTime;
import java.util.Map;

import com.web.curation.JWT.JWTDecoding;
import com.web.curation.dao.CommentDao;
import com.web.curation.model.BasicResponse;
import com.web.curation.model.Comment;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Api("Article Controller")
@ApiResponses(value = { @ApiResponse(code = 401, message = "Unauthorized", response = BasicResponse.class),
        @ApiResponse(code = 403, message = "Forbidden", response = BasicResponse.class),
        @ApiResponse(code = 404, message = "Not Found", response = BasicResponse.class),
        @ApiResponse(code = 500, message = "Failure", response = BasicResponse.class) })
@CrossOrigin
@RestController
public class CommentController {

    @Autowired
    CommentDao commentDao; 
    
    @ApiOperation(value = "댓글 등록")
    @PostMapping("/article/comment")
    public Object writeComment(@RequestBody(required = true) final Map<String, Object> request, @RequestHeader final HttpHeaders header)
            throws Exception {
        /*
        {
            "email" : "ssasfy@ssafy.com",
            "articleid" : "109",
            "content":"댓글입니당"
        }
        */

        final BasicResponse result = new BasicResponse();
        result.status = false;
        result.data = "댓글 등록 실패";

        String email = JWTDecoding.decode(header.get("id_token").get(0));
        int articleid = Integer.parseInt((String)request.get("articleid"));
        String content = (String) request.get("content");

        Comment comment = new Comment();
        comment.setArticleid(articleid);
        comment.setEmail(email);
        comment.setContent(content);


        if(commentDao.save(comment) == null){
            return new ResponseEntity<>(result, HttpStatus.OK);
        }
        
        result.status = true;
        result.data = (String) JWTDecoding.getInfo(header.get("id_token").get(0)).get("nickname");
        result.object = comment;

        return new ResponseEntity<>(result,HttpStatus.OK);
    }

    @Transactional
    @ApiOperation(value="댓글 삭제")
    @DeleteMapping("/article/comment")
    public Object deleteComment (@RequestParam(required = true) int no) {
        final BasicResponse result = new BasicResponse();

        if(commentDao.deleteByCommentid(no) > 0) {
            result.status = true;
            result.data = "삭제 성공";
        }
        else {
            result.status = false;
            result.data = "삭제 실패";
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @Transactional
    @ApiOperation(value="댓글 수정")
    @PutMapping("/article/comment")
    public Object updateComment(@RequestBody(required = true) final Map<String, Object> request) {
        /*
        {
        "commentId" : "5",
        "content":"내용내용"
       }
        */

        int commentId = Integer.parseInt((String) request.get("commentId"));
        
        Comment comment = commentDao.findByCommentid(commentId);
        comment.setContent((String) request.get("content"));
        comment.setUpdatedat(LocalDateTime.now());

        final BasicResponse result = new BasicResponse();
        result.data = "수정 실패";
        result.status = false;

        if(commentDao.save(comment) != null) {
            result.data = "수정 성공";
            result.status = true;
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
    
}