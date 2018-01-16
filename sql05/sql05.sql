/*문제1.
가장 늦게 입사한 직원의 이름(first_name last_name)과 연봉(salary)과 근무하는 
부서 이름(department_name)은?*/
select first_name || ' ' || last_name,
        salary,
        department_name,
        hire_date
from employees emp, departments dep
where emp.department_id=dep.department_id
and hire_date in (select max(hire_date)
                    from employees);

/*문제2.
평균연봉(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 이름(firt_name), 
성(last_name)과  업무(job_title), 연봉(salary)을 조회하시오.*/
select emp.employee_id "사번",
        emp.first_name "이름",
        emp.last_name "성",
        emp.salary "급여",
        a.avg avg_salary,
        jo.job_title
from employees emp, jobs jo,(select department_id, avg(salary) avg
                                from employees
                                group by department_id) a,(select max(avg(salary)) max_avg
                                                            from employees
                                                            group by department_id) b
where emp.job_id = jo.job_id
and a.department_id = emp.department_id
and a.avg=b.max_avg;

/*문제3.
평균 급여(salary)가 가장 높은 부서는?*/
select department_name
from departments dep, (select department_id, avg(salary) avg
                        from employees
                        group by department_id) a, (select max(avg(salary)) max_avg
                                                    from employees
                                                    group by department_id) b
where dep.department_id=a.department_id
and a.avg=b.max_avg;
                   
select department_name
from departments dep, (select department_id, avg(salary) avg
                        from employees
                        group by department_id) a
where dep.department_id=a.department_id 
and a.avg in (select max(avg(salary)) max_avg
                   from employees
                   group by department_id);

/*문제4.
평균 급여(salary)가 가장 높은 지역은?*/
select region_name
from countries coun, regions reg
        ,(select loc.country_id, avg(salary) avg
          from employees emp, departments dep, locations loc
          where emp.department_id=dep.department_id
          and dep.location_id=loc.location_id
          group by loc.country_id) a, (select max(avg(salary)) max_avg
                                        from employees emp, departments dep, locations loc
                                        where emp.department_id=dep.department_id
                                        and dep.location_id=loc.location_id
                                        group by loc.country_id) b
where coun.region_id=reg.region_id
and coun.country_id=a.country_id
and a.avg = b.max_avg;

select region_name
from locations loc, countries coun, regions reg
        ,(select dep.location_id, avg(salary) avg
          from employees emp, departments dep
          where emp.department_id=dep.department_id
          group by dep.location_id) a, (select max(avg(salary)) max_avg
                                        from employees emp, departments dep
                                        where emp.department_id=dep.department_id
                                        group by dep.location_id) b
where loc.country_id=coun.country_id
and coun.region_id=reg.region_id
and loc.location_id=a.location_id
and a.avg = b.max_avg;

/*문제5.
평균 급여(salary)가 가장 높은 업무는? */
select job_title
from jobs jo, (select job_id, avg(salary) avg
                 from employees
                 group by job_id) a, (select max(avg(salary)) max_avg
                                       from employees
                                       group by job_id) b
where jo.job_id=a.job_id
and a.avg = b.max_avg;