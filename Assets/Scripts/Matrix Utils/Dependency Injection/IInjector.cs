using UnityEngine;

public interface IInjector
{
    void Inject(MonoBehaviour injectable);
    void Inject(GameObject root);
}