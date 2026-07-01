using System;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class SceneTransitionerProxy : MonoBehaviour
{
    [SerializeField] float m_transitionDuration = 0.5f;
    [Inject] ISceneTransitioner m_sceneTransitioner;

    private void Start()
    {
        FindAnyObjectByType<Injector>().Inject(this);
    }

    public void TransitionToScene(string sceneName)
    {
        Time.timeScale = 1f;
        m_sceneTransitioner.TransitionToScene(sceneName, m_transitionDuration);
    }
    
}
