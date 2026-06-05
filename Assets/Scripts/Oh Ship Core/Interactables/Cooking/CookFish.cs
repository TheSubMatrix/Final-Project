using System.Collections;
using UnityEngine;

public class CookFish : MonoBehaviour
{
    Material material;
    float cookedAmount;
    bool isCooking = false;
    bool burned = false;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        material = GetComponent<Renderer>().material;
        cookedAmount = material.GetFloat("_Cooked_Amount");
    }

    // Update is called once per frame
    void Update()
    {
        //cookedAmount = material.GetFloat("_Cooked_Amount");
        Debug.Log("Cook:" + cookedAmount);
        CheckForStove();
        CheckCookedStatus();

        if(isCooking)
        {
            StartCooking();
        }
    }

    private void OnCollisionStay(Collision collision)
    {

    }

    private void StartCooking()
    {
        if(cookedAmount < 0.7f)
        {
            cookedAmount += 0.1f * Time.deltaTime;
            material.SetFloat("_Cooked_Amount", cookedAmount);
        }

        if(cookedAmount >= 0.7f)
        {
            burned = true;
            StartCoroutine(Burn());
        }
    }

    void EndCooking()
    {
        isCooking = false;
        Destroy(gameObject);
    }

    private void CheckCookedStatus()
    {

    }

    private void CheckForStove()
    {
        Vector3 origin = transform.position;
        Vector3 direction = Vector3.down;

        RaycastHit hit;

        Debug.DrawRay(origin, direction * 0.1f, Color.red);

        if (Physics.Raycast(origin, direction, out hit, 0.1f))
        {
            if (hit.collider.CompareTag("Stove"))
            {
                if(!isCooking)
                {
                    isCooking = true;
                }
            }
        }
    }

    private IEnumerator Burn()
    {
        yield return new WaitForSeconds(3);
        cookedAmount += 0.1f * Time.deltaTime;
        material.SetFloat("_Cooked_Amount", cookedAmount);

        if(cookedAmount >= 1)
        {
            EndCooking();
        }

    }
}
