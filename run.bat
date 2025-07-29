::[Bat To Exe Converter]
::
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydkuB40g7HWpmknPUjT8+LtFpjqM=
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydkuF6UU1JHdxl2yejiovAA==
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydkuc9V8/FmZ7im7Rgi91YtJ8+g==
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydk6M8kg4VWd1kwM=
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydk6A9FgkJHZghnHEmTt1YtJ8+g==
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydkSG4QUyGnEU
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydluK50UPCWBkiHCejiovAA==
::fBE1pAF6MU+EWHreyHcjLQlHcAiLOX2/OpET6/326uSTsXE6XfY3bY3nyrGcM+8d60nbZ5M92Wlmmd4YAwtNch64bR09uXpHpFiWNNWVoxvydluA61s8HlpzjnfvnD43bJ1qm9dj
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
::Zh4grVQjdCyDJGyX8VAjFBddSRKHAE+1BaAR7ebv/Nagq1kVQeADaIrJybuAIews+ED0eoUR129Ol9sZABdLfQCifhsxu1JQs2iANtSZoDP3GgbdqBoMGnBgiHPFgCcoY8FhitcGwW2orAOr0fQvgiqxW7ELdQ==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal enabledelayedexpansion

echo  starting program
echo ----------------------------------

call scripts/log.bat
call scripts/checkforupdate.bat
call scripts/first_startup.bat

echo Starting git pull process...
echo %date% %time% - Starting git pull process. >> "log\%AUTOPULL_LOGFILE%"
call scripts/simple_git_pull.bat

echo Program finished.
echo ----------------------------------
echo %date% %time% - Program finished. >> "log\%AUTOPULL_LOGFILE%"
pause