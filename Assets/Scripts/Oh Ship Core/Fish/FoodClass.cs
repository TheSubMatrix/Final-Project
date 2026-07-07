using System;
using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.Serialization;

public abstract class FoodClass : MonoBehaviour, IHeldItem
{
    [FormerlySerializedAs("foodData")] [SerializeField] protected SO_CookableFoodData m_foodData;
    public SO_CookableFoodData FoodData => m_foodData;

    public abstract CookingProcess CookingProcess { get; }

    public abstract CookState CookStateRef { get; }

    HungerAndThirst m_hungerAndThirst;

    public void InitializeHungerAndThirst(HungerAndThirst hungerAndThirst)
    {
        m_hungerAndThirst = hungerAndThirst;
        //Reset();
    }

    public void Use()
    {
        m_hungerAndThirst.Hunger.Value += Eat();
        if (GetComponentInParent<IHeldItemHandler>() is { } handler)
        {
            handler.TryClearHeldItem();
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public Transform GetTransform() => transform;
    public virtual Vector3 GetPositionOffset() => Vector3.zero;
    public virtual Quaternion GetRotationOffset() => Quaternion.identity;
    public GameObject GetAssociatedGameObject() => gameObject;
    public float GetCookingSpeed() => FoodData.CookSpeed;
    public virtual void UpdateCookedAmount(float amount) { }
    public virtual void Reset() { }
    public abstract float Eat();
}
