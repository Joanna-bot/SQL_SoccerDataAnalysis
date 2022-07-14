/*first look at the tables*/

select *
from "_Match" m 

select *
from country c 

select * 
from league l 

select * 
from player p 

select * 
from player_attributes pa 

select *
from team t 

select * 
from team_attributes ta 


/*GENERAL FINDINGS*/

/*matches per country, league and season*/

select c.name as country, l.name as league, m.season, count(m.id) 
from country c 
join league l 
on c.id=l.country_id
join "_Match" m 
on l.country_id=m.country_id 
group by c.name, l.name, m.season
order by c.name, l.name, m.season;

/*TEAM ANALYSIS*/

/*Number matches per team per season*/

select m.season, t.team_short_name, count(m.id)
from "_Match" m 
join team t 
on t.team_api_id = m.home_team_api_id 
join team_attributes ta 
on t.team_api_id = ta.team_api_id 
group by  m.season, t.team_short_name

/*was it victory, defeat or draw?*/

create view v_results as
select left(m.date,7), t.team_short_name, 
case 
	when m.home_team_goal>m.away_team_goal then 'victory'
	when m.home_team_goal<m.away_team_goal then 'defeat'
	else 'draw'
end as result
from "_Match" m 
join team t 
on t.team_api_id = m.home_team_api_id 
join team_attributes ta 
on t.team_api_id = ta.team_api_id 


/*number of vitories, defeats and draws pro team and year*/

select left(v_results.left,4) as year_n,  v_results.team_short_name, v_results.result,
	count(result)
from v_results
group by left(v_results.left,4), v_results.team_short_name, v_results.result
order by left(v_results.left,4) 


/*team ranking*/

/*best teams*/
select left(v_results.left,4) as year_n, v_results.team_short_name, count(v_results.result) as number_victories, 
	dense_rank() over (partition by left(v_results.left,4) order by count(v_results.result) desc) as ranking
from v_results
where v_results.result='victory'
group by left(v_results.left,4), v_results.team_short_name
order by left(v_results.left,4), count(v_results.result) desc, 
	dense_rank() over (partition by left(v_results.left,4) order by count(v_results.result)) 
	

/*worst teams*/

select left(v_results.left,4) as year_n, v_results.team_short_name, count(v_results.result) as number_defeats,
	dense_rank() over (partition by left(v_results.left,4) order by count(v_results.result) desc) as ranking
from v_results
where v_results.result='defeat'
group by left(v_results.left,4), v_results.team_short_name
order by left(v_results.left,4), count(v_results.result) desc, 
	dense_rank() over (partition by left(v_results.left,4) order by count(v_results.result)) 
	
/*team squad per season*/

create view v_TeamPlayers as
select distinct m.home_player_1 as player_api_id , m.home_team_api_id as team_api_id, m.season
from"_Match" m 
where home_player_1 is not null
union
select distinct home_player_2 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where home_player_2 is not null
union
select distinct home_player_3 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where home_player_3 is not null
union
select distinct home_player_4 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where home_player_4 is not null
union
select distinct home_player_5 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where home_player_5 is not null
union
select distinct home_player_6 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where home_player_6 is not null
union
select distinct home_player_7 as player_api_id, home_team_api_id AS team_api_id, season
from "_Match" 
where home_player_7 is not null
union
select distinct home_player_8 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where home_player_8 is not null
union
select distinct home_player_9 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where home_player_9 is not null
union
select distinct home_player_10 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where home_player_10 is not null
union
select distinct home_player_11 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where home_player_11 is not null
union
select distinct away_player_1 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_1 is not null
union
select distinct away_player_2 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_2 is not null
union
select distinct away_player_3 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_3 is not null
union
select distinct away_player_4 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_4 is not null
union
select distinct away_player_5 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_5 is not null
union
select distinct away_player_6 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_6 is not null
union
select distinct away_player_7 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_7 is not null
union
select distinct away_player_8 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_8 is not null
union
select distinct away_player_9 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_9 is not null
union
select distinct away_player_10 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_10 is not null
union
select distinct away_player_11 as player_api_id, home_team_api_id as team_api_id, season
from "_Match" 
where away_player_11 is not null;

/*team squad with full names*/

select distinct v_TeamPlayers.season, t.team_long_name, p.player_name 
from v_TeamPlayers
join team t 
on v_TeamPlayers.team_api_id::numeric = t.team_api_id::numeric 
join player p 
on p.player_api_id::numeric = v_TeamPlayers.player_api_id::numeric
order by v_TeamPlayers.season, t.team_long_name


/*team squad with body measures*/

select distinct v_TeamPlayers.season, t.team_long_name, p.player_name, p.height, p.weight  
from v_TeamPlayers
join player p 
on p.player_api_id::numeric = v_TeamPlayers.player_api_id::numeric
join team t 
on v_TeamPlayers.team_api_id::numeric = t.team_api_id::numeric 


select distinct v_TeamPlayers.season, t.team_long_name,  
avg(p.height) over (partition by t.team_long_name, v_TeamPlayers.season) as avg_height,
avg(p.weight ) over (partition by t.team_long_name, v_TeamPlayers.season) as avg_weight
from v_TeamPlayers
join player p 
on p.player_api_id::numeric = v_TeamPlayers.player_api_id::numeric
join team t 
on v_TeamPlayers.team_api_id::numeric = t.team_api_id::numeric 
order by avg(p.height) over (partition by t.team_long_name, v_TeamPlayers.season), avg(p.weight ) over (partition by t.team_long_name, v_TeamPlayers.season)


/*teams and leagues*/

create view v_LeagueTeams as
select distinct league_id, home_team_api_id
from "_Match" m 
where home_team_api_id is not null
union
select distinct league_id, away_team_api_id
from "_Match" 
where away_team_api_id is not null


	
/*MATCH ANALYSIS*/

/*home team analysis*/

select m.season, t.team_long_name, m.home_team_goal, count(m.match_api_id) as count_match, 
round(avg(m.home_team_goal) over (partition by m.home_team_api_id, m.season),2) as avg_per_team
from "_Match" m 
join team t 
on t.team_api_id = m.home_team_api_id 
join team_attributes ta 
on t.team_api_id = ta.team_api_id 
where m.goal is not null 
group by  m.season,t.team_long_name, m.home_team_goal, m.home_team_api_id

/*PLAYERS ANALYSIS*/
/*how body measures impact chosen performance indicators*/

select distinct p.player_name, p.height, p.weight, left(pa.date,4)::numeric-left(p.birthday, 4)::numeric as age_n, left(pa.date, 4) as rok, 
max(pa.overall_rating) as max_rating, max(pa.potential) as max_potential, max(pa.stamina) as max_stamina 
from player p 
join player_attributes pa 
on p.player_api_id =pa.player_api_id 
group by p.player_name, p.height, p.weight,pa.date, left(p.birthday,4)

/*BEST WORLD'S PLAYER ANALYS*/

/*checking development of Lewandowski's data*/

select p.player_name, pa.attacking_work_rate, pa.potential, pa.agility, left(pa.date,4) as year_n
from player p
join player_attributes pa 
on p.player_api_id =pa.player_api_id 
where player_name ilike '%Robert lewandowski%'
group by left(pa.date,4), p.player_name, pa.attacking_work_rate, pa.potential, pa.agility

/*checking which player had the highest potential ever*/

select max(pa.potential)
from player p
join player_attributes pa 
on p.player_api_id =pa.player_api_id 

select p.player_name
from player p
join player_attributes pa 
on p.player_api_id =pa.player_api_id 
where pa.potential = 97


/*checking how much the max potential differs from the potential of each player*/

select left(pa.date,4) as year_n, p.player_name, pa.potential,  
max(pa.potential) over (partition by left(pa.date,4)) as max_potential, 
max(pa.potential) over (partition by left(pa.date,4)) - pa.potential as difference,
round(avg(pa.potential) over (partition by left(pa.date,4)),2) as avg_potential
from player p
join player_attributes pa 
on p.player_api_id =pa.player_api_id 
where potential is not null 
group by left(pa.date,4), p.player_name, pa.attacking_work_rate, pa.potential, pa.agility
order by left(pa.date,4), max(pa.potential) over (partition by left(pa.date,4)) - pa.potential desc

/*comparing Lewandowski and Messi*/

select left(pa.date,4) as year_n, p.player_name, max(pa.stamina) as max_stamina, max(pa.strength) as max_strength, max(pa.agility) as max_agility, max(pa.heading_accuracy) as max_heading, max(pa.aggression) as max_aggression, max(pa.shot_power) as max_shot, max(pa.free_kick_accuracy) as max_kick, pa.attacking_work_rate, avg(pa.overall_rating) as avg_overall  
from player p
join player_attributes pa 
on p.player_api_id =pa.player_api_id 
where p.player_name ilike 'Robert lewandowski' or p.player_name ilike '%messi%'
group by left(pa.date,4), p.player_name, pa.attacking_work_rate


/*goalkeepers analysis*/
/*how many goals they passed through on matches at home pro season*/

select distinct m.home_player_1, p.player_name, m.season,t.team_long_name, sum(m.away_team_goal) 
from "_Match" m 
join player p 
on m.home_player_1::numeric  = p.player_api_id 
join team t 
on m.home_team_api_id = t.team_api_id 
group by m.season, t.team_long_name, p.player_name, m.home_player_1 
order by m.season 


/*how many goals they passed through on matches away pro season*/
select distinct m.away_player_1, p.player_name, m.season,t.team_long_name, sum(m.home_team_goal) 
from "_Match" m 
join player p 
on m.home_player_1::numeric  = p.player_api_id 
join team t 
on m.home_team_api_id = t.team_api_id 
group by m.season, t.team_long_name, p.player_name, m.away_player_1 
order by m.season 

/*list of all Szczesny's teams */

select distinct p.player_name, m.season,t.team_long_name, m.home_player_1  
from "_Match" m 
join player p 
on m.home_player_1::numeric  = p.player_api_id 
join team t 
on m.home_team_api_id = t.team_api_id 
where p.player_name ilike '%szczesny%'
group by m.season, t.team_long_name, p.player_name, m.home_player_1  
order by m.season 

/*number of all Szczesnys games at "home" and lost goals*/

select distinct p.player_name, m.season,t.team_long_name, count(m.match_api_id) as numer_matches, sum(away_team_goal) as lost_goals 
from "_Match" m 
join player p 
on m.home_player_1::numeric  = p.player_api_id 
join team t 
on m.home_team_api_id = t.team_api_id 
where p.player_name ilike '%szczesny%' and home_player_1  = '169718'
group by m.season, t.team_long_name, p.player_name
order by m.season 

/*number of all Szczesnys games at "away" and lost goals*/

select distinct p.player_name, m.season,t.team_long_name, count(m.match_api_id) as numer_matches, sum(home_team_goal) as lost_goals 
from "_Match" m 
join player p 
on m.home_player_1::numeric  = p.player_api_id 
join team t 
on m.home_team_api_id = t.team_api_id 
where p.player_name ilike '%szczesny%' and away_player_1  = '169718'
group by m.season, t.team_long_name, p.player_name
order by m.season 



/*team changes and impact on performance*/

select distinct m.season,t.team_long_name, p.player_name, count(m.match_api_id) as numer_matches, sum(home_team_goal) as lost_goals 
from "_Match" m 
join player p 
on m.home_player_1::numeric  = p.player_api_id 
join team t 
on m.home_team_api_id = t.team_api_id 
group by m.season, t.team_long_name, p.player_name
order by m.season 







