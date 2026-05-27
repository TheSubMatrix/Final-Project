using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerInteraction : MonoBehaviour
{
    bool bIsLoaded = false;
    bool aIsLoaded = false;
    private string currentPlayer = "";
    [SerializeField] private Camera cam;
    [SerializeField] private Transform spawnPoint;
    void Awake()
    {
        DontDestroyOnLoad(gameObject);
    }
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        //cam = GetComponent<Camera>();
        spawnPoint = GameObject.FindWithTag("Spawn").transform;
        gameObject.transform.position = spawnPoint.position;

        SetCameras();
    }

    // Update is called once per frame
    void Update()
    {
        //aIsLoaded = SceneManager.GetSceneByName("Scene A").isLoaded;
        //bIsLoaded = SceneManager.GetSceneByName("Scen

        currentPlayer = gameObject.tag;
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag == "Bottom" && !bIsLoaded)
        {
            LoadCorrectScene("Scene B");
        }

        if(other.gameObject.tag == "Top" && !aIsLoaded)
        {
            LoadCorrectScene("Scene A");
        }
    }

    void LoadCorrectScene(string sceneName)
    {
        int layerIndex = LayerMask.NameToLayer(sceneName);
        if(currentPlayer == "Player01")
        {
            SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive);
            cam.cullingMask &= ~(1 << layerIndex);
        }

        if(sceneName == "Scene A")
        {
            bIsLoaded = false;
            bIsLoaded = true;
        }
        else if(sceneName == "Scene B")
        {
            bIsLoaded = true;
            aIsLoaded = false;
        }
    }

    void SetCameras()
    {
        if(currentPlayer == "Player01")
        {
            cam.rect = new Rect(0f, 0f, 0.5f, 1.0f);
        }

        if(currentPlayer == "Player02")
        {
            cam.rect = new Rect(0.5f, 0f, 0.5f, 1.0f);
        }
    }
}
