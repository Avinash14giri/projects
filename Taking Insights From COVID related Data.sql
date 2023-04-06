select*
From PortfolioProject..CovidDeaths
Order by 3,4

--select*
--From PortfolioProject..CovidVaccinations
--Order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2


--- Looking at Total case vs Total Deaths
--- Shows total death percentage

Select Location, total_cases, date, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
where location ='India'
Order by 1,2


----- Looking at total cases vs the population
----- Shows what percentage of population gets covis affected

Select Location, date,total_cases, population , (total_cases/Population)*100 as cases_as_population
From PortfolioProject..CovidDeaths
---where location ='India'
Order by 1,2


---- Looking at countries with highest infection rate compared to population


Select Location, population ,max(total_cases) as Highest_infection_count,  (max(total_cases/Population))*100 as Highest_Infection_rate
From PortfolioProject..CovidDeaths
Group by location, population
Order by Highest_Infection_rate desc


--- Showing countries with highest death as per population population


Select Location ,max(cast(total_deaths as int)) as Highest_death_count
From PortfolioProject..CovidDeaths
where continent is not null
Group by location 
Order by Highest_death_count desc


--- Let's break things down by continent
--- Showing highes death count by continent

Select Continent ,max(cast(total_deaths as int)) as Highest_death_count
From PortfolioProject..CovidDeaths
where Continent is not null
Group by Continent 
Order by Highest_death_count desc  


----Global numbers
--(ERRORRRRRR)Need to settle this later

Select  sum(new_cases) as TotalCases,sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int)) as TotalDeaths / sum(new_cases) as TotalCases * 100 
as deathpercentage
From PortfolioProject..CovidDeaths
where continent is not null
Order by 1,2

----Looking at total population and vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CoNVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =vac.location
	and dea.date =vac.date
where dea.continent is not null
order by 2,3


---USE CTE

With Popvsvac ( Continent,location,	date, population, new_vaccinations,RollingPeopleVaccinated)
As
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CoNVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =vac.location
	and dea.date =vac.date
where dea.continent is not null)--- order by is not used

Select *, (RollingPeopleVaccinated/population)*100 as peopleVaccinated From Popvsvac


--- TEMP table
Drop table if exists #PercentPolulationvaccinated 
Create table #PercentPolulationvaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPolulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CoNVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =vac.location
	and dea.date =vac.date
---where dea.continent is not null

Select *, (RollingPeopleVaccinated/population)*100 as peopleVaccinated From #PercentPolulationvaccinated



---Creating View to store data for later visualisations

Create view PercentPolulationvaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CoNVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =vac.location
	and dea.date =vac.date
where dea.continent is not null