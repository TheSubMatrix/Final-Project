using UnityEngine;

public class WarningSymbol : MonoBehaviour
{
   [SerializeField] private float rotationSpeed;
   [SerializeField] private float floatSpeed;
   [SerializeField] private float floatHeight;
   private Vector3 m_startPos;
    void Start()
    {
        m_startPos = transform.localPosition;
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Vector3.up, (rotationSpeed * 10) * Time.deltaTime);
        float y = m_startPos.y + Mathf.Sin(Time.time * floatSpeed) * floatHeight;
        transform.localPosition = new Vector3(m_startPos.x, y,  m_startPos.z);
    }
}
