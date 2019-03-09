using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotator : MonoBehaviour
{
    
    private void Update()
    {
        // Multiplying by Time.deltaTime to ensure that the rotation is smooth
        transform.Rotate(new Vector3(15, 30, 45) * Time.deltaTime);    
    }
}
