package com.web.curation.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.web.curation.dao.KeywordsDao;
import com.web.curation.dao.SearchDao;
import com.web.curation.dao.SkillsDao;
import com.web.curation.dao.pinlikesfollow.LikesDao;
import com.web.curation.dao.pinlikesfollow.PinDao;
import com.web.curation.model.Article;
import com.web.curation.model.BasicResponse;
import com.web.curation.model.Keywords;
import com.web.curation.model.Search;

@Api("Search Controller")
@ApiResponses(value = { @ApiResponse(code = 401, message = "Unauthorized", response = BasicResponse.class),
        @ApiResponse(code = 403, message = "Forbidden", response = BasicResponse.class),
        @ApiResponse(code = 404, message = "Not Found", response = BasicResponse.class),
        @ApiResponse(code = 500, message = "Failure", response = BasicResponse.class) })
@CrossOrigin
@RestController
public class SearchController {

    @Autowired
    SearchDao searchDao;

    @Autowired
    SkillsDao skillsDao; 

    @Autowired
    KeywordsDao keywordsDao;
    
    @Autowired
    LikesDao likesDao;

    @Autowired
    PinDao pinDao;

    @ApiOperation(value = "글 검색")
    @GetMapping("/article/search")
    // @GetMapping("/article/search?q={q}&category={category}&page={page}")
    public Object searchArticle(@RequestParam String q, @RequestParam String category, @RequestParam int page) {
        final BasicResponse result = new BasicResponse();

        result.status = false;
        result.data = "글 검색 실패";

        // int page2 = Integer.parseInt(page);

        // 글 검색
        Specification<Article> s = null;
        switch(category) {
            case "content":
                s = Search.searchByContent(q);
                break;
            case "title" :
                s = Search.searchByTitle(q);
                break;
            case "nickname" :
                s = Search.searchByNickname(q);
                break;
            default:
                return new ResponseEntity<>(result, HttpStatus.OK);
        }

        Page<Article> articles = searchDao.findAll(s, PageRequest.of(page, 10, Sort.Direction.DESC,"articleid"));
       
        // 키워드 받아오기
        List<List<String>> keywordsList = new ArrayList<>();
        List<Integer> likesList = new ArrayList<>();
        List<Integer> pinList = new ArrayList<>();

        for(Article a : articles){
            List<Keywords> tmpKeyword = keywordsDao.findAllByArticleid(a.getArticleid());
            if(tmpKeyword!=null){ // 임시리스트 만들어서 키워드들 넣고, 최종 리스트에 담음
                List<String> tmplist = new ArrayList<>();                   
                 for(Keywords k : tmpKeyword){
                        tmplist.add(skillsDao.findSkillBySno(k.getSno()).getName());
                    }
                keywordsList.add(tmplist);
            }
            else {
                result.data="keyword 조회 실패";                    
                return new ResponseEntity<>(result, HttpStatus.OK); // 글에 keyword 없으면 false return
            }
            likesList.add(likesDao.countByArticleid(a.getArticleid()));
            pinList.add(pinDao.countByArticleid(a.getArticleid()));
        }

        Map<String,Object> object = new HashMap<>();
        object.put("article",articles);
        object.put("keyword", keywordsList);
        object.put("likesCntList", likesList);
        object.put("pinCntList", pinList);

       if(!articles.isEmpty()){
           result.status = true;
           result.data = "success";
           result.object = object;
       }

       
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
    
}