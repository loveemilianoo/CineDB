package dao;

import conexion.Conexion;
import entity.Transaccion;
import java.sql.*;
import java.time.LocalDateTime;

public class TransaccionDAO {
    public int crearTransaccion(Transaccion transaccion) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int idTransaccion = 0;
        
        try {
            conn = new Conexion().getConexion();
            
            String query = "INSERT INTO tablas.transaccion (fecha_hora, total, metodo_pago) " +
                          "VALUES (?, ?, ?) RETURNING id_transaccion";
            
            ps = conn.prepareStatement(query);
            
            LocalDateTime fechaHora = transaccion.getFechaHora();
            if (fechaHora != null) {
                ps.setTimestamp(1, Timestamp.valueOf(fechaHora));
            } else {
                ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now())); 
            }
            ps.setBigDecimal(2, transaccion.getTotal());
            ps.setString(3, transaccion.getMetodoPago());
            
            rs = ps.executeQuery();
            if (rs.next()) {
                idTransaccion = rs.getInt("id_transaccion");
            }
        } catch (SQLException e) {
            System.out.println("Error al crear transacción: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return idTransaccion;
    }
    
}