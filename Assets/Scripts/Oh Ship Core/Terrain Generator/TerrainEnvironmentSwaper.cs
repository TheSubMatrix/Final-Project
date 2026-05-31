using UnityEngine;

public class TerrainEnvironmentSwaper
{
    public SO_WaterPathingTerrain changeCurrentTerrainTiles(SO_WaterPathingTerrain currentTerrainTiles, SO_WaterPathingTerrain newTerrainTiles)
    {
        SO_WaterPathingTerrain newPath = currentTerrainTiles != newTerrainTiles ? newTerrainTiles : currentTerrainTiles;
        return newPath;
    }
}
