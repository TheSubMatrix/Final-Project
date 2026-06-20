using UnityEngine;

public abstract class FoodClass : MonoBehaviour
{
 [SerializeField] protected SO_CookableFoodData foodData;
 
 public abstract CookingProcess CookingProcess { get; }

 public abstract void Use();
}
