using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.EventSystems;
using UnityEngine.UIElements;
using Random = UnityEngine.Random;

public class TerrainSpawner : MonoBehaviour
{
    [SerializeField] SO_WaterPathingTerrain usableTerrain;
    
    private Dictionary<string, GameObject> _terrainDictionary;
    
    public static Action<GameObject> OnCleanupTerrain;
    
    private readonly TerrainSelector _terrainSelector = new TerrainSelector();
    
    public List<GameObject> spawnedTerrains = new List<GameObject>();

    private string _currentTileKey = "0";

    void Awake()
    {
        _terrainDictionary = usableTerrain.possibleTiles;
    }
    void Start()
    {

        if (_terrainDictionary.TryGetValue(_currentTileKey, out GameObject terrain))
        {
            GameObject tile = Instantiate(terrain, new Vector3(0, 0, 0), Quaternion.identity);
            spawnedTerrains.Add(tile);
        }

        

    }

    // Update is called once per frame
    void Update()
    {
        if (spawnedTerrains.Count >= 4)
        {
            if (spawnedTerrains[0] != null)
            {
              
                Destroy(spawnedTerrains[0]);
                spawnedTerrains.RemoveAt(0);
            }
            
        }
        if (Keyboard.current.spaceKey.wasPressedThisFrame)
        {
            string currentTileKey = _terrainSelector.PickNextTile(_currentTileKey, usableTerrain.terrainOptions);
            
            if (_terrainDictionary.TryGetValue(currentTileKey, out GameObject terrain))
            {
                Vector3 spawnLocation = spawnedTerrains[^1].transform.Find("Exit Point").position;
                GameObject tile = Instantiate(terrain, Vector3.zero, Quaternion.identity);
                tile.transform.position = spawnLocation - tile.transform.Find("Entry Point").position;
                spawnedTerrains.Add(tile);
                
                _currentTileKey = currentTileKey;
                
                Debug.Log($"Spawned Terrain Key: {currentTileKey}");
            }
            
            
        }
    }
    
}
