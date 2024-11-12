USE test; 
ALTER TABLE building
ADD FOREIGN KEY (host_id) REFERENCES host(id);
ALTER TABLE building
ADD FOREIGN KEY (contractor_id) REFERENCES contractor(id);

ALTER TABLE design 
ADD FOREIGN KEY (building_id) REFERENCES building(id),
ADD FOREIGN KEY (architect_id) REFERENCES architect(id);

ALTER TABLE work
ADD FOREIGN KEY (building_id) REFERENCES building(id),
ADD FOREIGN KEY (worker_id) REFERENCES worker(id);

SELECT * FROM test.building;
-- Hiển thị thông tin công trình có chi phí cao nhất
SELECT  * FROM  test.building 
WHERE cost = (
	SELECT MAX(cost) FROM building
);
-- Hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở Cần Thơ
SELECT * FROM test.building
WHERE cost > ALL(
	SELECT cost FROM building 
    WHERE `city` = 'can tho'
);
-- Hiển thị thông tin công trình có chi phí lớn hơn một trong các công trình được xây dựng ở Cần Thơ
SELECT * FROM test.building
WHERE cost > ANY (
	SELECT cost FROM building 
    WHERE `city` = 'can tho'
);
-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế
SELECT * FROM test.design
WHERE  architect_id = NULL;
-- Hiển thị thông tin các kiến trúc sư cùng năm sinh và cùng nơi tốt nghiệp
SELECT 
    YEAR(birthday) AS birth_year, 
    place, 
    COUNT(*) AS architect_count
FROM architect
GROUP BY 
    YEAR(birthday), 
    place
HAVING COUNT(*) > 1;
-- Exercise 04
-- Hiển thị thù lao trung bình của từng kiến trúc sư
SELECT AVG(benefit) AS `trung bình thù lao`
FROM design;
-- Hiển thị chi phí đầu tư cho các công trình ở mỗi thành phố
SELECT 
	city, 
    SUM(cost) AS total_cost
FROM building
GROUP BY city;
-- Tìm các công trình có chi phí trả cho kiến trúc sư lớn hơn 50
SELECT  
	name, cost
FROM building 
WHERE cost < 50; 
-- Tìm các thành phố có ít nhất một kiến trúc sư tốt nghiệp
SELECT DISTINCT place FROM architect;
-- Exercise 05

-- Hiển thị tên công trình, tên chủ nhân và tên chủ thầu của công trình đó
SELECT `name`, host_id as `ten chu nhan`, contractor_id as `tem chủ thầu`
FROM building;
-- Hiển thị tên công trình (building), tên kiến trúc sư (architect) 
-- và thù lao của kiến trúc sư ở mỗi công trình (design)

SELECT
     building.name as `ten cong trinh`,
     architect.name as `ten kien truc`,
     benefit as `thu lao`
FROM building
INNER JOIN architect
INNER JOIN design; 

-- Hãy cho biết tên và địa chỉ công trình (building) do chủ thầu Công ty xây dựng số 6 thi công (contractor)
SELECT 
	building.name as `ten cong trinh`,
    building.address as `dia chi`
FROM building 
JOIN 
    contractor ON building.id = contractor.id
WHERE contractor.name = 'cty xd so 6';
-- Tìm tên và địa chỉ liên lạc của các chủ thầu (contractor) thi công công trình ở Cần Thơ (building) 
-- do kiến trúc sư Lê Kim Dung thiết kế (architect, design)
SELECT 
    contractor.name AS contractor_name, 
    contractor.address AS contractor_contact
FROM 
    contractor 
JOIN 
    building ON contractor.id = building.contractor_id
JOIN 
    design ON building.id = design.building_id
JOIN 
    architect  ON design.architect_id = architect.id
WHERE 
    building.city = 'can tho'
    AND architect.name = 'le kim dung';
-- Hãy cho biết nơi tốt nghiệp của các kiến trúc sư (architect) 
-- đã thiết kế (design) công trình Khách Sạn Quốc Tế ở Cần Thơ (building)
SELECT 
	architect.name as `ten kien truc su`,
	architect.place AS `noi tot nghiep`
FROM architect 
JOIN 
    design ON architect.id = design.architect_id
JOIN 
    building ON design.building_id = building.id
WHERE 
    building.name = 'Khách Sạn Quốc Tế'
    AND building.city = 'Cần Thơ';


-- Cho biết họ tên, năm sinh, năm vào nghề của các công nhân có chuyên môn hàn hoặc điện (worker) 
-- đã tham gia các công trình (work) mà chủ thầu Lê Văn Sơn (contractor) đã trúng thầu (building)

SELECT 
    worker.name AS worker_name, 
    worker.birthday, 
    worker.year
FROM 
    worker 
JOIN 
    work ON worker.id = work.worker_id
JOIN 
    building ON work.building_id = building.id
JOIN 
    contractor ON building.contractor_id = contractor.id
WHERE 
    worker.skill IN ('han', 'dien')
    AND contractor.name = 'le van son';

-- Những công nhân nào (worker) đã bắt đầu tham gia công trình Khách sạn Quốc Tế ở Cần Thơ (building) 
-- trong giai đoạn từ ngày 15/12/1994 đến 31/12/1994 (work) số ngày tương ứng là bao nhiêu
SELECT 
    worker.name AS worker_name, 
    DATEDIFF(LEAST(work.date, '1994-12-31'), GREATEST(work.date, '1994-12-15')) + 1 AS days_worked
FROM worker 
JOIN 
    work ON worker.id = work.worker_id
JOIN 
    building ON work.building_id = building.id
WHERE 
    building.name = 'Khách sạn Quốc Tế'
    AND building.city = 'Cần Thơ'
    AND work.date BETWEEN '1994-12-15' AND '1994-12-31';
-- Cho biết họ tên và năm sinh của các kiến trúc sư đã tốt nghiệp ở TP Hồ Chí Minh (architect) 
-- và đã thiết kế ít nhất một công trình (design) có kinh phí đầu tư trên 400 triệu đồng (building)


-- Cho biết tên công trình có kinh phí cao nhất
-- Cho biết tên các kiến trúc sư (architect) vừa thiết kế các công trình (design) do Phòng dịch vụ sở xây dựng (contractor) thi công vừa thiết kế các công trình do chủ thầu Lê Văn Sơn thi công
-- Cho biết họ tên các công nhân (worker) có tham gia (work) các công trình ở Cần Thơ (building) nhưng không có tham gia công trình ở Vĩnh Long
-- Cho biết tên của các chủ thầu đã thi công các công trình có kinh phí lớn hơn tất cả các công trình do chủ thầu phòng Dịch vụ Sở xây dựng thi công
-- Cho biết họ tên các kiến trúc sư có thù lao thiết kế một công trình nào đó dưới giá trị trung bình thù lao thiết kế cho một công trình
-- Tìm tên và địa chỉ những chủ thầu đã trúng thầu công trình có kinh phí thấp nhất
-- Tìm họ tên và chuyên môn của các công nhân (worker) tham gia (work) các công trình do kiến trúc sư Le Thanh Tung thiet ke (architect) (design)
-- Tìm các cặp tên của chủ thầu có trúng thầu các công trình tại cùng một thành phố
-- Tìm tổng kinh phí của tất cả các công trình theo từng chủ thầu
-- Cho biết họ tên các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
-- Cho biết số lượng các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
-- Tìm tổng số công nhân đã than gia ở mỗi công trình
-- Tìm tên và địa chỉ công trình có tổng số công nhân tham gia nhiều nhất
-- Cho biêt tên các thành phố và kinh phí trung bình cho mỗi công trình của từng thành phố tương ứng
-- Cho biết họ tên các công nhân có tổng số ngày tham gia vào các công trình lớn hơn tổng số ngày tham gia của công nhân Nguyễn Hồng Vân
-- Cho biết tổng số công trình mà mỗi chủ thầu đã thi công tại mỗi thành phố
-- Cho biết họ tên công nhân có tham gia ở tất cả các công trình





