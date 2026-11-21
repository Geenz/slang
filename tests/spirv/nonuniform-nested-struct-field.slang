//TEST:SIMPLE(filecheck=CHECK):-target spirv -entry main -stage fragment -emit-spirv-directly -O1

// A nonuniform descriptor index must remain decorated at the pointer used by
// the final field load after SPIR-V optimization.
// CHECK-DAG: OpCapability StorageBufferArrayNonUniformIndexing
// CHECK-DAG: %[[ELEMENT:[A-Za-z0-9_]+]] = OpAccessChain %{{[A-Za-z0-9_]+}} %{{[A-Za-z0-9_]+}} %{{[A-Za-z0-9_]+}} %{{[A-Za-z0-9_]+}}
// CHECK-DAG: %[[FIELD:[A-Za-z0-9_]+]] = OpAccessChain %{{[A-Za-z0-9_]+}} %[[ELEMENT]] %{{[A-Za-z0-9_]+}}
// CHECK-DAG: %[[VALUE:[A-Za-z0-9_]+]] = OpLoad %{{[A-Za-z0-9_]+}} %[[FIELD]]
// CHECK-DAG: OpDecorate %[[FIELD]] NonUniform

struct Probe { float4 offsetAndState; float4 flags; };
StructuredBuffer<Probe> pages[4];

float4 main(float4 pos : SV_Position) : SV_Target
{
    uint page = NonUniformResourceIndex(uint(pos.x) % 4);
    return pages[page][uint(pos.y) % 8].flags;
}
