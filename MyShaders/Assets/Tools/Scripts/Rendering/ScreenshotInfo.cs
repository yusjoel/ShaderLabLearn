using System;
using System.Collections.Generic;
using UnityEngine;

namespace Gempoll.Editor.Rendering
{
    [Serializable]
    public class ScreenshotInfo
    {
        public Vector3 CameraPosition;
        public Vector3 CameraEulerAngles;
        public float CameraFieldOfView;
        public float CameraNearClipPlane;
        public float CameraFarClipPlane;
        public List<Renderer> Renderers;

        //private Vector3 ReadVector3(BinaryReader binaryReader)
        //{
        //    var v = new Vector3(binaryReader.ReadSingle(), binaryReader.ReadSingle(), binaryReader.ReadSingle());
        //    return v;
        //}

        //private void WriteVector3(Vector3 v, BinaryWriter binaryWriter)
        //{
        //    binaryWriter.Write(v.x);
        //    binaryWriter.Write(v.y);
        //    binaryWriter.Write(v.z);
        //}

        //public void Read(BinaryReader binaryReader)
        //{
        //    CameraPosition = ReadVector3(binaryReader);
        //    CameraEulerAngles = ReadVector3(binaryReader);
        //    CameraFieldOfView = binaryReader.ReadSingle();
        //    CameraNearClipPlane = binaryReader.ReadSingle();
        //    CameraFarClipPlane = binaryReader.ReadSingle();
        //    int count = binaryReader.ReadInt32();
        //    ObjectPaths = new string[count];
        //    for (int i = 0; i < count; i++)
        //        ObjectPaths[i] = binaryReader.ReadString();
        //}

        //public void Write(BinaryWriter binaryWriter)
        //{
        //    WriteVector3(CameraPosition, binaryWriter);
        //    WriteVector3(CameraEulerAngles, binaryWriter);
        //    binaryWriter.Write(CameraFieldOfView);
        //    binaryWriter.Write(CameraNearClipPlane);
        //    binaryWriter.Write(CameraFarClipPlane);
        //    binaryWriter.Write(ObjectPaths.Length);
        //    foreach (string objectPath in ObjectPaths)
        //        binaryWriter.Write(objectPath);
        //}
    }
}
