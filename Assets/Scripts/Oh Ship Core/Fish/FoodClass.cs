using UnityEngine;

public abstract class FoodClass : MonoBehaviour
{
 [SerializeField] protected SO_CookableFoodData foodData;
 
 public abstract CookingProcess CookingProcess { get; }
 
 private HungerAndThirst m_HungerAndThirst;

 public void InitializeHungerAndThirst(HungerAndThirst hungerAndThirst)
 {
  m_HungerAndThirst = hungerAndThirst;
 }

 public void Use()
 {
  m_HungerAndThirst.Hunger.Value += Eat();
 }

 public abstract float Eat();

}
