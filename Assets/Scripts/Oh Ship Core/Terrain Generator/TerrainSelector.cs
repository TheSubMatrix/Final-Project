using UnityEngine;

public class TerrainSelector
{
    public string PickNextTile(string currentTileKey, TerrainOptions[] tileOptions)
    {
        foreach (TerrainOptions tileOption in tileOptions)
        {
            if (currentTileKey == tileOption.currentTileKey)
            {
                return tileOption.tileOptions[Random.Range(0, tileOption.tileOptions.Length)];
            }
        }

        return "0";
    }
}
