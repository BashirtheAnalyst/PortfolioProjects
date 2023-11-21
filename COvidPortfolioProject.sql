Select *
From PortfolioProject..CovidDeaths
Order by 3, 4


--Select *
--From PortfolioProject..CovidVaccination
--Order by 3, 4

--Selecting Data to be Used
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order By 1,2

-- Comparing Total cases against Total Deaths in US
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where Location Like '%states%'
Order By 1,2

--Checking the Total Cases against Population
Select Location, date, total_cases, population, (total_cases/population)*100 AS PercentpopulationInfected
From PortfolioProject..CovidDeaths
Order By 1,2

-- Checking for highest Infection rate against population
Select Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)* 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Analysing Highest deaths count per country
Select Location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount -- Casted because it was in character form
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Analyzing the death count per continent
Select location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount -- Casted because it was in character form
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

Select continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount -- Casted because it was in character form
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- WORLD RECORDS
SELECT date, SUM(new_cases) AS daily_infection, SUM(CAST(new_deaths AS int)) AS Daily_death, SUM(CAST(new_deaths AS int))/SUM(new_cases)* 100 AS DailyDeathRate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

-- Joining two tables and Extracting data from them
SELECT cd.continent, cd.location, cd.date, cv.new_vaccinations, 
	SUM(CAST(cv.new_vaccinations AS int)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) AS PeopleVaccinatedDaily
FROM PortfolioProject..CovidDeaths cd
JOIN PortfolioProject..CovidVaccination cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3

--Using CTE
WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinatedDaily) AS
(
	SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
		SUM(CONVERT(int, cv.new_vaccinations)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) AS PeopleVaccinatedDaily
	FROM PortfolioProject..CovidDeaths cd
	JOIN PortfolioProject..CovidVaccination cv
		ON cd.location = cv.location
		AND cd.date = cv.date
	WHERE cd.continent IS NOT NULL
)
SELECT *, (PeopleVaccinatedDaily/Population)*100 PercentVaccinated
FROM PopVsVac

-- Crating TEMP TABLE
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
( Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
PeopleVaccinatedDaily numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
		SUM(CONVERT(int, cv.new_vaccinations)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) AS PeopleVaccinatedDaily
FROM PortfolioProject..CovidDeaths cd
JOIN PortfolioProject..CovidVaccination cv
	ON cd.location = cv.location
	AND cd.date = cv.date
--WHERE cd.continent IS NOT NULL

SELECT *, (PeopleVaccinatedDaily/Population)*100 PercentVaccinated
FROM #PercentPopulationVaccinated

-- Creating data for Visualization
CREATE View PercentPopulationVaccinated AS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
		SUM(CONVERT(int, cv.new_vaccinations)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) AS PeopleVaccinatedDaily
FROM PortfolioProject..CovidDeaths cd
JOIN PortfolioProject..CovidVaccination cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated