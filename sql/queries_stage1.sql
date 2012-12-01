-- Stage 1

-- Query 1
select phone_number from students where surname='Smith';

-- Query 2
select s.surname, s.firstname, s.phone_number
from student_courses sc
join students s on sc.student_phone_number = s.phone_number
where sc.student_number=100001;

-- Query 3
select s.surname, s.firstname, count(distinct sc.course_code)
from students s
join student_courses sc on s.phone_number = sc.student_phone_number
group by s.phone_number, s.surname, s.firstname
having count(distinct sc.course_code)>1;

-- Query 4
select t.postcode_district, t.name, c.name, count(distinct s.phone_number)
from towns t
join addresses a on t.id = a.town_id
join students s on a.id = s.address_id
join counties c on c.id = t.county_id
group by t.postcode_district, t.name, c.name;

-- Query 5
select t.postcode_district, t.name, c.name, sc.year, sc.course_code, count(distinct s.phone_number)
from towns t
join addresses a on t.id = a.town_id
join students s on a.id = s.address_id
join student_courses sc on s.phone_number = sc.student_phone_number
join counties c on c.id = t.county_id
group by t.postcode_district, t.name, c.name, sc.year, sc.course_code;

-- Query 6
select a.number, a.street, a.postcode_area, t.name, t.postcode_district, count(distinct s.phone_number)
from addresses a
join students s on a.id = s.address_id
join towns t on t.id = a.town_id
group by a.id, a.number, a.street, a.postcode_area, t.name, t.postcode_district
having count(distinct s.phone_number)>1;