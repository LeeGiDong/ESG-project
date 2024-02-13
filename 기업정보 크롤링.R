library(rvest)
library("openxlsx")
# 경로 설정 
dirname <- "추가정보"
# 폴더 생성
# dir.create(dirname)

df = data.frame(matrix(ncol = 4))
names(df) = c("기업명","영역구분","상장여부","산업분류")

for(page_num in 1:16) {
  defualt_url <- "https://ksaesg.or.kr/p_base.php?action=h_report_04&board_id=&s_text=&s_category=&page="
  lm_2_url <- paste0(defualt_url,page_num)
  # url html로 읽어오기
  lm_2_html <- read_html(lm_2_url)
  
  # 해당 Table css 
  lm_2_table <- lm_2_html %>% 
    html_nodes(".table")
  
  # 각 리스트의 href 읽어오기 
  lm_2_file_url <- lm_2_table %>% 
    html_nodes("td") %>% 
    html_node("a") %>% 
    html_attr("href")
  
  # na 제거
  lm_2_file_url <- lm_2_file_url[complete.cases(lm_2_file_url)]
  lm_2_file_url <- paste0("https://ksaesg.or.kr/",lm_2_file_url)
  # 동일-----------------------------------------------------------------------
  # 각 Url 로 접근 하여 파일을 뽑아오기
  for(for_url in lm_2_file_url) {
    
    # Download url 가져오기
    file_url <- read_html(for_url) %>% 
      html_nodes(".table") %>% 
      html_nodes("td") %>% 
      html_text()
    
    
    Ent <- file_url[1]
    pr <- file_url[2]
    cr <- file_url[3]
    sec <- file_url[4]
    df = rbind(df,c(Ent,pr,cr,sec))

    # 위에서 쓴 for문 닫기
  } 
} 

write.xlsx(df,file = "기업추가정보.xlsx")
