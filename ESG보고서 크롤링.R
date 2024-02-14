library(rvest)
# 경로 설정 
dirname <- "ESG보고서"
# 폴더 생성
dir.create(dirname)

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
  
  if(FALSE){
    lm_2_file_url_tmp = lm_2_file_url
    lm_2_file_url = lm_2_file_url_tmp[23:length(lm_2_file_url_tmp)]
  }
  
  # 각 Url 로 접근 하여 파일을 뽑아오기
  for(for_url in lm_2_file_url) {
    
    # Download url 가져오기
    file_url <- read_html(for_url) %>% 
      html_nodes(".table") %>% 
      html_nodes("a") %>% 
      html_attr("href")
    
    # Download name 생성
    file_name <- read_html(for_url) %>% 
      html_nodes(".table") %>% 
      html_nodes("a") %>% 
      html_text()
    file_name = gsub("/", "_", file_name)
    
    # 파일 다운로드
    destfile_name <- paste0(getwd(),"/",dirname,"/",file_name)
    download.file(paste0("https://ksaesg.or.kr/",file_url),destfile = paste0(destfile_name, ".pdf"),mode = "wb")
    
  } 
} 
