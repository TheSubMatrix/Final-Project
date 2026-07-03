using UnityEngine;

public class PlaceOfInterestAnimationValues : MonoBehaviour
{
    private Animator m_animator;
    [SerializeField] private float m_minSize;
    [SerializeField] private float m_maxSize;
    void Start()
    {
       m_animator = GetComponent<Animator>(); 
    }

    // Update is called once per frame
    void Update()
    {
        float t = m_animator.GetFloat("Scale");
        float scale = Mathf.Lerp(m_minSize, m_maxSize, t);
        float x = 1 * scale;
        float y = 1 * scale;
        transform.localScale = new Vector3(x,y,transform.localScale.z);
    }
}
