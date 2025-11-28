package dao;

import conexion.Conexion;
import entity.Funcion;
import java.sql.*;
import java.util.*;

public class FuncionDAO {
    public List<Funcion> getFunciones() {
        List<Funcion> funciones = new ArrayList();
        Connection conn = null;
        Conexion conexion = new Conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = conexion.getConexion();

            String queryIdPelicula = "SELECT id_pelicula FROM tablas.pelicula";
            ps = conn.prepareStatement(queryIdPelicula, Statement.RETURN_GENERATED_KEYS);
            rs = ps.executeQuery();

            int idPelicula = 0;
            int idSala = 0;

            while (rs.next()) {
                idPelicula = rs.getInt("id_pelicula");
            }
            ///
            String queryIdSala = "SELECT id_sala FROM tablas.sala";
            ps = conn.prepareStatement(queryIdSala, Statement.RETURN_GENERATED_KEYS);
            rs = ps.executeQuery();

            while (rs.next()) {
                idSala = rs.getInt("id_sala");
            }
            ///
            String query = "SELECT * FROM tablas.funcion WHERE id_pelicula=? AND id_sala=?";
            ps = conn.prepareStatement(query);

            ps.setInt(1, idPelicula);
            ps.setInt(2, idSala);
            rs = ps.executeQuery();

            ResultSetMetaData rsmd = rs.getMetaData();
            int columnas = rsmd.getColumnCount();
            while (rs.next()) {
                Funcion funcion = new Funcion();
                funcion.setIdFuncion(rs.getInt("id_funcion"));
                funcion.setIdPelicula(rs.getInt("id_pelicula"));
                funcion.setIdSala(rs.getInt("id_sala"));
                funciones.add(funcion);
            }
        } catch (Exception e) {
            System.out.println("Error " + e.toString());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (ps != null)
                    ps.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return funciones;
    }
}
