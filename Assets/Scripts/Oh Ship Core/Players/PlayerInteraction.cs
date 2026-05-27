using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerInteraction : MonoBehaviour
{
    bool bIsLoaded = false;
    bool aIsLoaded = false;
    private string currentPlayer = "";
    [SerializeField] private Camera cam;
    [SerializeField] private Transform spawnPoint;
    private int playerCount = 0;

    bool inSceneA = false;
    bool inSceneB = false;

    int layerIndex;


    void Awake()
    {
        DontDestroyOnLoad(gameObject);
    }
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        cam = GetComponentInChildren<Camera>();

        if (GameObject.FindGameObjectsWithTag("Player01").Length > 0)
        {
            gameObject.tag = "Player02";
        }
        else if (GameObject.FindGameObjectsWithTag("Player").Length > 0)
        {
            gameObject.tag = "Player01";
        }

        currentPlayer = gameObject.tag;


        //cam = GetComponent<Camera>();
        spawnPoint = GameObject.FindWithTag("Spawn").transform;
        gameObject.transform.position = spawnPoint.position;

        SetCameras();
    }

    // Update is called once per frame
    void Update()
    {
        aIsLoaded = SceneManager.GetSceneByName("Scene A").isLoaded;
        bIsLoaded = SceneManager.GetSceneByName("Scene B").isLoaded;
        Debug.Log(cam.GetInstanceID());
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag == "Bottom")
        {
            if (!bIsLoaded)
            {
                LoadCorrectScene("Scene B");
            }
            else
            {
                ShowCorrectScene("Scene B");
            }
            Spawn();
        }

        if(other.gameObject.tag == "Top")
        {
            if(!aIsLoaded)
            {
                LoadCorrectScene("Scene A");
            }
            else
            {
                ShowCorrectScene("Scene A");
            }
            Spawn();
        }
    }

    void LoadCorrectScene(string sceneName)
    {

        SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive);

    }

    void ShowCorrectScene(string sceneName)
    {
        int defaultLayer = LayerMask.NameToLayer("Default");
        int sceneALayer = LayerMask.NameToLayer("Scene A");
        int sceneBLayer = LayerMask.NameToLayer("Scene B");

        if (sceneName == "Scene A")
        {
            cam.cullingMask =
                (1 << defaultLayer) |
                (1 << sceneALayer);
        }

        if (sceneName == "Scene B")
        {
            cam.cullingMask =
                (1 << defaultLayer) |
                (1 << sceneBLayer);
        }
        //layerIndex = LayerMask.NameToLayer(sceneName);
        //cam.cullingMask = ~(1 << layerIndex);
        SetCameras();
    }

    void Spawn()
    {
        spawnPoint = GameObject.FindWithTag("Spawn").transform;
        gameObject.transform.position = spawnPoint.position;
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
