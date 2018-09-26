import kotlin.native.concurrent.*


@ThreadLocal
private var gyroSumComputer: GyroSumComputer? = null

class GyroSumWorker {

    var listener: GyroSumWorkerListener? = null
    private val worker = Worker.start()

    init {
        worker.execute(TransferMode.SAFE, { GyroSumComputer() }) {
            gyroSumComputer = it
        }
    }

    fun performOperation(input: InputData) {
        input.freeze()
        worker.execute(TransferMode.SAFE, { input }) {
            val res = gyroSumComputer?.performOperation(it)
            println("res = " + res) // res is not null
            res
        }.consume { outputData ->
            println("outputData = " + outputData) // Seems to be null all the time
            outputData?.let { listener?.gyroSumUpdate(it) }
        }
    }
}

interface GyroSumWorkerListener {
    fun gyroSumUpdate(outputData: OutputData)
}
