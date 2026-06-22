using UnityEngine;

[ExecuteAlways]
public class LightingManager : MonoBehaviour
{
    [SerializeField] private Light directionalLight;
    [SerializeField] private LightingPreset preset;
    [SerializeField, Range(0, 96)] private float timeOfDay;
    [SerializeField] private GameObject[] lights;
    private int lightCount;
    private bool lightSetUp = false;
    private bool finishedLightUp = true;

    private void UpdateLighting(float timePercentage)
    {
        RenderSettings.ambientLight = preset.ambientColor.Evaluate(timePercentage);
        RenderSettings.fogColor = preset.fogColor.Evaluate(timePercentage);

        if(directionalLight != null)
        {
            directionalLight.color = preset.directionColor.Evaluate(timePercentage);
            directionalLight.transform.localRotation = Quaternion.Euler(new Vector3((timePercentage * 360f) - 90f, 170f, 0));
        }
    }

    private void Start()
    {
        lights = GameObject.FindGameObjectsWithTag("Light");
    }

    private void Update()
    {

        if(!lightSetUp)
        {
            lightCount = lights.Length;
            lightSetUp = true;
        }

        Debug.Log("light count:" + lightCount);

        if (preset == null)
        {
            return;
        }

        if(Application.isPlaying)
        {
            timeOfDay += Time.deltaTime;
            timeOfDay %= 96;
            UpdateLighting(timeOfDay/96f);
        }
        else
        {
            UpdateLighting(timeOfDay / 96f);
        }

        if(timeOfDay <= 20 || timeOfDay >= 84)
        {
            if (lightCount > 0 && finishedLightUp)
            {
                finishedLightUp = false;
                Invoke("LightUp", Random.Range(0.1f, 1f));
            }
        }
        else
        {
            foreach(var light in lights) 
            {
                light.SetActive(false);
                lightSetUp = false;
            }
    }}
    private void OnValidate()
    {
        if(directionalLight != null)
        {
            return;
        }

        if(RenderSettings.sun != null)
        {
            directionalLight = RenderSettings.sun;
        }
        else
        {
            Light[] lights = GameObject.FindObjectsOfType<Light>();
            foreach (Light light in lights)
            {
                if(light.type == LightType.Directional)
                {
                    directionalLight = light;
                    return;
                }
            }
        }
    }

    private void LightUp()
    {
        GameObject chosenLight = lights[Random.Range(0, lights.Length)];

        if(chosenLight.activeSelf)
        {
            LightUp();
        }
        else
        {
            chosenLight.SetActive(true);
            finishedLightUp = true;
            lightCount--;
        }
    }
}
