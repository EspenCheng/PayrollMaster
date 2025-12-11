export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm">
        <h1 className="text-4xl font-bold text-center mb-8">
          PayrollMaster
        </h1>
        <p className="text-center text-gray-600">
          企业薪酬管理系统
        </p>
        <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="p-6 border rounded-lg">
            <h2 className="text-xl font-semibold mb-2">薪酬计算</h2>
            <p className="text-gray-600">自动计算员工薪酬</p>
          </div>
          <div className="p-6 border rounded-lg">
            <h2 className="text-xl font-semibold mb-2">报表生成</h2>
            <p className="text-gray-600">生成各类薪酬报表</p>
          </div>
          <div className="p-6 border rounded-lg">
            <h2 className="text-xl font-semibold mb-2">数据管理</h2>
            <p className="text-gray-600">管理员工和薪资数据</p>
          </div>
        </div>
      </div>
    </main>
  )
}
