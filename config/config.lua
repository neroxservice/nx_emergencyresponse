Config = {}

Config.DispatchJob = "ambulance"
Config.DispatchTitle = "Medizinischer Notfall"
Config.DispatchMessage = "Ein Notfallarmband hat ein Notfall gemeldet"

Config.SpawnInterval = 2700000 -- 45 minuten 2700000

Config.PossibleScenarios = {
    {
        anim = "dead",
        blood = true,
        fire = false
    },
    {
        anim = "sitting",
        blood = true,
        fire = false
    },
    {
        anim = "brandopfer",
        blood = true,
        fire = true
    }
}

Config.SpawnLocations = {
    vector3(215.76, -810.12, 30.73),
    vector3(-2037.1758, 2848.2026, 32.8104),

}
