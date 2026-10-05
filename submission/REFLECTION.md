# Reflection — Lab 19

**Tên:** Nguyen Quang Minh
**Cohort:** A20-K4
**Path đã chạy:** lite

## Reflection (≤ 200 words)

Trên bộ dữ liệu chuẩn (golden set) gồm 50 truy vấn không đổi, chỉ số Precision@10 đạt 77,8% đối với BM25,
73,2% đối với tìm kiếm ngữ nghĩa (semantic search) và 78,6% đối với phương pháp lai RRF (k=60, thứ hạng bắt đầu từ 1).
Phương pháp lai giúp cải thiện chất lượng tổng thể thêm 0,8 điểm phần trăm so với BM25
và 5,4 điểm so với tìm kiếm ngữ nghĩa.

Đối với các truy vấn chính xác (exact queries), BM25 và phương pháp lai đạt kết quả ngang bằng là 96,7%,
vượt trội hơn so với mức 88,7% của tìm kiếm ngữ nghĩa. Các thuật ngữ kỹ thuật cụ thể
giúp phương pháp khớp từ khóa (keyword matching) phát huy hiệu quả. Với các truy vấn hỗn hợp,
phương pháp lai đạt 100%, so với 97,0% của BM25 và 98,5% của tìm kiếm ngữ nghĩa:
cơ chế kết hợp (fusion) đã tận dụng được các bảng xếp hạng bổ trợ cho nhau.

Đối với các câu diễn giải lại (paraphrases), BM25 đạt 33,3%, tìm kiếm ngữ nghĩa đạt 24,0%
và phương pháp lai đạt 32,0%. Mô hình bge-small (vốn tập trung vào tiếng Anh) gặp khó khăn
với các câu diễn giải lại bằng tiếng Việt; cơ chế kết hợp không thể khắc phục được
độ liên quan yếu của các vector nhúng (embedding). Các kết quả đo lường này
không ủng hộ nhận định rằng tìm kiếm vector luôn vượt trội đối với các câu diễn giải lại.

Tôi sẽ sử dụng BM25 thuần túy cho các mã định danh và thuật ngữ kỹ thuật chính xác
khi yếu tố độ trễ (latency) được ưu tiên. Tôi sẽ chọn tìm kiếm vector thuần túy cho
các câu diễn giải lại mang tính khái niệm chỉ sau khi đã kiểm chứng một mô hình đa ngôn ngữ phù hợp.
Phương pháp lai hữu ích cho các truy vấn hỗn hợp nhưng lại làm tăng chi phí tính toán vector nhúng và kết hợp,
đồng thời có thể làm giảm hiệu quả của bảng xếp hạng từ khóa vốn đang tốt hơn trong nhóm dữ liệu diễn giải lại này.

Các notebook nâng cao và thử thách bổ sung (tùy chọn) đã được lược bỏ.