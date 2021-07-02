-- Covid Data Exploration

select * from CovidDeaths ;

select location , date , total_cases, new_cases, total_deaths, population 
from CovidDeaths
order by 1,2 -- order by date and location

select location , date , total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%morocco%' --Shows likelihood of dying if you get covid in your country
order by location,date

select location , date , total_cases, population, (total_cases/population)*100 as CovidPercentage
from CovidDeaths
where location like '%morocco%' --Shows likelihood of getting covid in your country
order by location,date

--Looking at countries with highest infection Rate Compared to population

select location, population, Max(total_cases) as highestInfectionCount, Max((total_cases/population))*100 as InfectionPercentage
from CovidDeaths
where continent is not null
group by location, population
order by InfectionPercentage desc


--Looking at countries with highest Death Rate 

select location, Max(total_deaths) as highestDeathCount
from CovidDeaths
where continent is not null
group by location
order by highestDeathCount desc


--Looking at continent with highest Death Rate 

select continent, Max(total_deaths) as highestDeathCount
from CovidDeaths
where continent is not null
group by continent
order by highestDeathCount desc


--Global Numbers total

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths , (sum(new_deaths)/ sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null



--Global Numbers

select date,sum(new_cases) as total_cases, sum(new_deaths) as total_deaths , (sum(new_deaths)/ sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1,2



--Looking at total population vs Vaccinations
-- Using CTE


with PopvsVac (continent, location, date , population,new_vaccinations,RollingTotalVacc)
as (

select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingTotalVacc
from CovidDeaths as d
Join CovidVaccinations as v
     on d.location = v.location 
	 and d.date = v.date
where d.continent is not null

)
select * ,(RollingTotalVacc/population)*100 as VaccinationPercentage
from PopvsVac


--Looking at total population vs Vaccinations
-- Using Temp Table

drop table if exists #PercentPopulationVaccinated 
create table #PercentPopulationVaccinated
( continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingTotalVacc numeric
	)

insert into #PercentPopulationVaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingTotalVacc
from CovidDeaths as d
Join CovidVaccinations as v
     on d.location = v.location 
	 and d.date = v.date
where d.continent is not null


select * ,(RollingTotalVacc/population)*100 as VaccinationPercentage
from #PercentPopulationVaccinated


--Creating Views for Later Visualization

create view PercentPopulationVaccinated as 
select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingTotalVacc
from CovidDeaths as d
Join CovidVaccinations as v
     on d.location = v.location 
	 and d.date = v.date
where d.continent is not null
