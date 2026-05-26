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
    
    private Dictionary<string, GameObject> _TerrainDictionary;
    
    public static Action<GameObject> OnCleanupTerrain;
    
    private TerrainSelector _terrainSelector = new TerrainSelector();
    
    public List<GameObject> _spawnedTerrains = new List<GameObject>();

    private string _currentTileKey = "0";

    void Awake()
    {
        _TerrainDictionary = usableTerrain.possibleTiles;
    }
    void Start()
    {

        if (_TerrainDictionary.TryGetValue(_currentTileKey, out GameObject terrain))
        {
            GameObject tile = Instantiate(terrain, new Vector3(0, 0, 0), Quaternion.identity);
            _spawnedTerrains.Add(tile);
        }

    }

    // Update is called once per frame
    void Update()
    {
        if (_spawnedTerrains.Count >= 4)
        {
            if (_spawnedTerrains[0])
            {
              //  Debug.Log($"Destroying Terrain Key: {_currentTileKey}");
                Destroy(_spawnedTerrains[0]);
                _spawnedTerrains.RemoveAt(0);
            }
            
        }
        if (Keyboard.current.spaceKey.wasPressedThisFrame)
        {
            Debug.Log("Spawning Terrain");
            
            string currentTileKey = _terrainSelector.PickNextTile(_currentTileKey);
            
            if (_TerrainDictionary.TryGetValue(currentTileKey, out GameObject terrain))
            {
                GameObject tile = Instantiate(terrain, new Vector3(0, 0, 0), Quaternion.identity);
                _spawnedTerrains.Add(tile);
                Debug.Log($"Spawned Terrain Key: {currentTileKey}");
            }
            
            _currentTileKey = currentTileKey;
        }
    }
    
}
