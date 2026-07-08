using System.Collections;
using MatrixUtils.Attributes;
using UnityEngine;
using UnityEngine.Animations.Rigging;
using UnityEngine.Serialization;

public class HeldItemHandler: MonoBehaviour, IHeldItemHandler
{
    public IHeldItem HeldItem { get; private set; }
    Coroutine m_moveArmWeightCoroutine;
    public bool IsHoldingItem => HeldItem != null;
    [SerializeField] float m_armSpeed = 2f;
    public bool TryHoldItem(IHeldItem item)
    {
        if(IsHoldingItem) return false;
        item.GetTransform().SetParent(transform);
        Debug.Log("<color=green>Held item</color>");
        item.GetTransform().localPosition = item.GetPositionOffset();
        item.GetTransform().localRotation = item.GetRotationOffset();
        HeldItem = item;
        if(m_moveArmWeightCoroutine != null){ StopCoroutine(m_moveArmWeightCoroutine);}
        m_moveArmWeightCoroutine = StartCoroutine(MoveArmWeight(1, m_armSpeed));
        return true;
    }
    
    public bool TryDropItem()
    {
        if(!IsHoldingItem) return false;
        HeldItem.GetTransform().SetParent(null);
        HeldItem = null;
        if(m_moveArmWeightCoroutine != null){ StopCoroutine(m_moveArmWeightCoroutine);}
        m_moveArmWeightCoroutine = StartCoroutine(MoveArmWeight(0, m_armSpeed));
        return true;
    }

    public bool TryClearHeldItem()
    {
        if(!IsHoldingItem) return false;
        foreach(Transform child in transform)
        {
            Destroy(child.gameObject);
        }
        HeldItem = null;
        if(m_moveArmWeightCoroutine != null){ StopCoroutine(m_moveArmWeightCoroutine);}
        m_moveArmWeightCoroutine = StartCoroutine(MoveArmWeight(0, m_armSpeed));
        return true;
    }

    public GameObject GetAssociatedGameObject() => gameObject;
    [FormerlySerializedAs("objectHoldConstraint"), RequiredField] public TwoBoneIKConstraint m_objectHoldConstraint;

    IEnumerator MoveArmWeight(float desiredWeight, float speed)
    {
        float startWeight = m_objectHoldConstraint.weight;
        float distance = Mathf.Abs(desiredWeight - startWeight);
        if (distance <= Mathf.Epsilon)
        {
            m_objectHoldConstraint.weight = desiredWeight;
            yield break;
        }
        float duration = distance / speed;
        float timeElapsed = 0;
        while (timeElapsed <= duration)
        {
            m_objectHoldConstraint.weight = Mathf.Lerp(startWeight, desiredWeight, timeElapsed / duration);
            timeElapsed += Time.deltaTime;
            yield return null;
        }
        m_objectHoldConstraint.weight = desiredWeight;
        m_moveArmWeightCoroutine = null;
    }
    
    

        /*/| _ ╱|、
         ( •̀ㅅ •́ )
        ＿ノヽノ＼＿
        /　`/ ⌒Ｙ⌒ Ｙ\
      ( 　(三ヽ人　 /　|
        |　ﾉ⌒＼ ￣￣ヽノ
      ヽ＿＿＿＞､＿＿／
        ｜( 王 ﾉ〈
        /ﾐ`ー―彡\
     | ╰    ╯  |
     |     /\   |
     |    /  \  |
     |  /    \ |                  */
}
