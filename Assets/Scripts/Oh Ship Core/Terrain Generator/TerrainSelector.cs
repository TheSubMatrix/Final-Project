using UnityEngine;

public class TerrainSelector
{
    public string PickNextTile(string currentTileKey)
    {
        switch (currentTileKey)
        {
            case "0":
                return Random.Range(0, 2) == 0 ? "1a" : "1b";
            case "1a":
                return "2a";
            case "1b":
                return "2b";
            case "2b":
                return "0";
            case "2a":
                return "0";
            default:
                Debug.LogError("Invalid tile key. Forced to default state and spawned key 0 tile.");
                return "0";
        }
    }
}
