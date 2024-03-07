import pandas as pd
import fitz  # PyMuPDF
import os

# 경로 설정
os.chdir("C:/Users/Administrator/Desktop/ESG보고서")

# Excel 파일에서 데이터 로드
add = pd.read_excel("기업추가정보.xlsx", sheet_name=1)
report_names = add["최종보고서명"]

ceo_messages = []

for i in range(330, len(report_names)):
    pdf_file = os.path.join(os.getcwd(), f"{report_names[i]}.pdf")

    # PDF 파일 읽기
    doc = fitz.open(pdf_file)
    text = ""
    start_page = None  # 시작 페이지
    end_page = None  # 종료 페이지

    for page_num in range(len(doc)):
        page = doc.load_page(page_num)
        page_text = page.get_text()

        # 시작 페이지 설정
        if ("인사말" in page_text or "존경하는" in page_text or "CEO Message" in page_text or "Message to Stakeholders" in page_text or "안녕하십니까" in page_text or "CEO 메시지" in page_text )and start_page is None:
            start_page = page_num

        # 종료 페이지 설정
        if start_page is not None and end_page is None:
            if "대표집행임원" in page_text or "대표이사" in page_text or "회장" in page_text :
                end_page = page_num

        # 모든 페이지 텍스트 연결
        text += page_text

    # 특정 범위의 텍스트 추출
    if start_page is not None and end_page is not None:
        extracted_text = ""
        for page_num in range(start_page, end_page + 1):
            page = doc.load_page(page_num)
            extracted_text += page.get_text()
    else:
        extracted_text = "x"

    ceo_messages.append(extracted_text.replace("\n", ""))


output_file = "ceo_messages.txt"
with open(output_file, "w", encoding="utf-8") as file:
    for i, message in enumerate(ceo_messages, start=1):
        file.write(f"{i}. {message}\n\n\n")