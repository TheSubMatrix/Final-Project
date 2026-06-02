using UnityEngine;

public class BoatCoordinate : MonoBehaviour
{
    [SerializeField] private float rayCastLength = 100f;
    private RaycastHit _hit;

    private int _allowedLayerMasks;
    // Update is called once per frame
    void Awake()
    {
        DisableChildCollidersFromRayCast();
    }
    void Update()
    {
        Debug.DrawRay(gameObject.transform.position, Vector3.down * rayCastLength, Color.red);
        if (Physics.Raycast(gameObject.transform.position, Vector3.down, out _hit, rayCastLength, _allowedLayerMasks))
        {
            Debug.Log(_hit.transform.name);
        }
    }

    private void DisableChildCollidersFromRayCast()
    {
        int ignoreLayers = 1 << gameObject.layer;
        Collider[] childrenColliders = GetComponentsInChildren<Collider>();
        
        foreach (Collider childCollider in childrenColliders)
        {
            ignoreLayers |= (1 << childCollider.gameObject.layer);
        }
        
        _allowedLayerMasks = ~ignoreLayers;
    }

    public bool ShipHasChangedTerrainTiles()
    {
        return false;
    }
}
