::[Bat To Exe Converter]
::
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydkmc8kQPHGxguHPFgCd1YtJ8+g==
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydkuG6E05HHBmhmHVsywydOx4j88PnSK/6C0=
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydk6M8kg4VWd1kwM=
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFBddSRKHAE+1BaAR7ebv/Nagq1kVQeADaIrJybuAIews+ED0eoUR129Ol9sZABdLfQCifhsxu1JQs2iANtSZoDP1T0ad5185DWA6gnvV7A==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal enabledelayedexpansion

echo  starting program
echo ----------------------------------

set /p "auto=Do you want to run default configurations? (y/n): "

if /i "%auto%"=="y" (
    echo Running default configurations...
    call auto_git_pull.bat

) else (
    echo Skipping default configurations.
    call configurabe_git_pull.bat
)

echo Program finished.
echo ----------------------------------
pause