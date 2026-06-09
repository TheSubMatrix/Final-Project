using System.Collections;
using UnityEngine;
using System;

public class CookFish : MonoBehaviour, IInteractable
{
    Material material;
    float cookedAmount;
    bool isCooking = false;
    bool isReady = false;
    bool isBurnt = false;
    bool isBurning = false;


    [SerializeField] Stats stats;
    [SerializeField] SimpleStatModifier modifier;
    [SerializeField] StatData hungerStatToModify;

    InteractionSession m_currentInteractionSession;

    StatBroker mediator;


    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        material = GetComponent<Renderer>().material;
        cookedAmount = material.GetFloat("_Cooked_Amount");
    }

    // Update is called once per frame
    void Update()
    {
        CheckForStove();

        if(isCooking)
        {
            StartCooking();
        }
    }


    private void StartCooking()
    {
        if(cookedAmount < 0.7f)
        {
            cookedAmount += 0.1f * Time.deltaTime;
            material.SetFloat("_Cooked_Amount", cookedAmount);
        }

        if(cookedAmount >= 0.7f && !isReady)
        {
            isCooking = false;
            isReady = true;
            if(!isBurning)
            {
                StartCoroutine(Burn());
            }
        }
    }

    void EndCooking()
    {
        isReady = false;
        isBurnt = false;
        isBurning = false;
        gameObject.SetActive(false);
        material.SetFloat("_Cooked_Amount", 0f);
        cookedAmount = 0f;
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
        isBurning = true;
        yield return new WaitForSeconds(3);
        cookedAmount += 0.1f * Time.deltaTime;
        material.SetFloat("_Cooked_Amount", cookedAmount);

        if(cookedAmount >= 1)
        {
            isBurnt = true;
        }

    }

    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        if (interactor.IsInteracting() || m_currentInteractionSession is { IsActive: true }) return null;

        if (isBurnt)
        {
            Discard();
        }
        else if(isReady)
        {
            Eat();
        }
        else if(isCooking)
        {
            return null;
        }
        return m_currentInteractionSession;
    }

    private void Eat()
    {
        Func<float, float> Add = (x) => x + 5;
        modifier = new SimpleStatModifier(Add, hungerStatToModify);
        mediator = stats.broker;
        mediator.AddModifier(modifier);

        Debug.Log(hungerStatToModify);
        EndCooking();
        gameObject.SetActive(false);

    }

    private void Discard()
    {
        EndCooking();
    }

}
